package DATN.service;

import DATN.dto.MoMoPaymentRequestDTO;
import DATN.dto.MoMoPaymentResponseDTO;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.apache.commons.codec.digest.HmacUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MoMoPaymentService {

    @Value("${momo.partner-code:MOMO}")
    private String partnerCode;

    @Value("${momo.access-key:F8BBA842ECF85}")
    private String accessKey;

    @Value("${momo.secret-key:K951B6PE1waDMi640xX08PD3vg6EkVlz}")
    private String secretKey;

    @Value("${momo.endpoint:https://test-payment.momo.vn/v2/gateway/api/create}")
    private String endpoint;

    @Value("${momo.redirect-url:http://localhost:8080/api/thanhtoan/momo/return}")
    private String redirectUrl;

    @Value("${momo.notify-url:http://localhost:8080/api/thanhtoan/momo/notify}")
    private String notifyUrl;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public MoMoPaymentResponseDTO createPayment(String orderId, Long amount, String orderInfo) {
        try {
            String requestId = UUID.randomUUID().toString();
            String extraData = "";
            String requestType = "payWithATM";
            String autoCapture = "true";
            String lang = "vi";

            // Tạo raw signature
            String rawSignature = "accessKey=" + accessKey +
                    "&amount=" + amount +
                    "&extraData=" + extraData +
                    "&ipnUrl=" + notifyUrl +
                    "&orderId=" + orderId +
                    "&orderInfo=" + orderInfo +
                    "&partnerCode=" + partnerCode +
                    "&redirectUrl=" + redirectUrl +
                    "&requestId=" + requestId +
                    "&requestType=" + requestType;

            // Tạo signature
            String signature = HmacUtils.hmacSha256Hex(secretKey, rawSignature);

            // Tạo request body
            MoMoPaymentRequestDTO requestBody = new MoMoPaymentRequestDTO();
            requestBody.setPartnerCode(partnerCode);
            requestBody.setPartnerName("Test");
            requestBody.setStoreId("MomoTestStore");
            requestBody.setRequestId(requestId);
            requestBody.setAmount(amount);
            requestBody.setOrderId(orderId);
            requestBody.setOrderInfo(orderInfo);
            requestBody.setRedirectUrl(redirectUrl);
            requestBody.setIpnUrl(notifyUrl);
            requestBody.setLang(lang);
            requestBody.setRequestType(requestType);
            requestBody.setAutoCapture(autoCapture);
            requestBody.setExtraData(extraData);
            requestBody.setSignature(signature);

            // Gửi request
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<MoMoPaymentRequestDTO> entity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<MoMoPaymentResponseDTO> response = restTemplate.postForEntity(
                    endpoint, entity, MoMoPaymentResponseDTO.class);

            return response.getBody();

        } catch (Exception e) {
            e.printStackTrace();
            MoMoPaymentResponseDTO errorResponse = new MoMoPaymentResponseDTO();
            errorResponse.setResultCode(-1);
            errorResponse.setMessage("Lỗi khi tạo thanh toán MoMo: " + e.getMessage());
            return errorResponse;
        }
    }

    public boolean verifySignature(String signature, String rawData) {
        try {
            String expectedSignature = HmacUtils.hmacSha256Hex(secretKey, rawData);
            return signature.equals(expectedSignature);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}