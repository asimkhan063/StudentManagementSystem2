package com.example.school_management.ai;

import com.openai.client.OpenAIClient;
import com.openai.models.ChatModel;
import com.openai.models.chat.completions.ChatCompletion;
import com.openai.models.chat.completions.ChatCompletionCreateParams;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Service;

@Service
public class AiService {

    private final OpenAIClient openAIClient;

    public AiService(ObjectProvider<OpenAIClient> openAIClientProvider) {
        this.openAIClient = openAIClientProvider.getIfAvailable();
    }

    public boolean isAvailable() {
        return openAIClient != null;
    }

    public String askAI(String question) {
        String safeQuestion = question == null ? "" : question.trim();
        if (safeQuestion.isEmpty()) {
            return "Apna sawal type kijiye.";
        }
        if (safeQuestion.length() > 1000) {
            safeQuestion = safeQuestion.substring(0, 1000);
        }
        if (!isAvailable()) {
            return "AI abhi configure nahi hai.";
        }

        ChatCompletionCreateParams params = ChatCompletionCreateParams.builder()
                .model(ChatModel.GPT_4O_MINI)
                .addSystemMessage("You are a helpful assistant inside a school management system. "
                        + "Help admins, teachers, students, and parents with school workflows, "
                        + "attendance, classes, subjects, and general learning questions. "
                        + "Reply in the language used by the user, keep answers clear and concise, "
                        + "and never claim to access private school records or perform an action "
                        + "unless the application explicitly provides that capability.")
                .addUserMessage(safeQuestion)
                .build();

        ChatCompletion response = openAIClient.chat()
                .completions()
                .create(params);

        return response.choices()
                .get(0)
                .message()
                .content()
                .orElse("AI se response nahi mila.");
    }
}
