<!-- ================= AI ASSISTANT ================= -->

<style>
    #aiAssistantButton {
        position: fixed;
        right: 25px;
        bottom: 25px;
        width: 60px;
        height: 60px;
        border-radius: 50%;
        border: none;
        background: #0d9488;
        color: white;
        font-size: 28px;
        cursor: pointer;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.25);
        z-index: 9999;
        display: grid;
        place-items: center;
    }

    #aiAssistantButton:hover {
        transform: scale(1.08);
        background: #0f766e;
    }

    #aiChatBox {
        display: none;
        position: fixed;
        right: 25px;
        bottom: 95px;
        width: 360px;
        height: 500px;
        background: white;
        border-radius: 18px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
        overflow: hidden;
        z-index: 9999;
        flex-direction: column;
    }

    @media (max-width: 480px) {
        #aiChatBox {
            inset: auto 12px 88px;
            width: auto;
            height: min(70vh, 520px);
        }
        #aiAssistantButton { right: 16px; bottom: 16px; }
    }

    #aiChatHeader {
        background: #0d9488;
        color: white;
        padding: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    #aiChatHeader h3 {
        margin: 0;
        font-size: 18px;
    }

    #aiCloseButton {
        background: transparent;
        border: none;
        color: white;
        font-size: 22px;
        cursor: pointer;
    }

    #aiMessages {
        flex: 1;
        padding: 15px;
        overflow-y: auto;
        background: #f8fafc;
    }

    .ai-message {
        background: #e2e8f0;
        padding: 10px 12px;
        border-radius: 12px;
        margin-bottom: 10px;
        max-width: 85%;
        font-size: 14px;
    }

    .user-message {
        background: #0d9488;
        color: white;
        padding: 10px 12px;
        border-radius: 12px;
        margin-bottom: 10px;
        margin-left: auto;
        max-width: 85%;
        font-size: 14px;
    }

    #aiInputArea {
        display: flex;
        padding: 10px;
        border-top: 1px solid #ddd;
        background: white;
    }

    #aiQuestion {
        flex: 1;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        outline: none;
    }

    #aiSendButton {
        margin-left: 8px;
        padding: 10px 15px;
        border: none;
        border-radius: 8px;
        background: #0d9488;
        color: white;
        cursor: pointer;
    }

    #aiSendButton:hover {
        background: #0f766e;
    }
</style>

<!-- Floating AI Button -->
<button id="aiAssistantButton" type="button" onclick="openAIChat()" aria-label="Open school AI assistant" title="Ask the school AI assistant">
    <svg aria-hidden="true" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M12 3v2M8 11h.01M16 11h.01M8.5 16h7"/><rect x="4" y="7" width="16" height="13" rx="4"/><path d="M4 12H2m20 0h-2"/>
    </svg>
</button>

<!-- Chat Box -->
<div id="aiChatBox">

    <div id="aiChatHeader">
        <h3>School AI Assistant</h3>

        <button id="aiCloseButton" type="button" onclick="closeAIChat()" aria-label="Close assistant">
            ×
        </button>
    </div>

    <div id="aiMessages">

        <div class="ai-message">
            Namaste! Main aapka School AI Assistant hoon. Students, teachers, attendance ya padhai se jude sawal poochhiye.
        </div>

    </div>

    <div id="aiInputArea">

        <input
                type="text"
                id="aiQuestion"
                placeholder="Apna sawal likhiye..."
                maxlength="1000"
                autocomplete="off"
                onkeydown="handleAIEnter(event)"
        >

        <button id="aiSendButton" type="button" onclick="askAI()">
            Poochhein
        </button>

    </div>

</div>

<script>

    function openAIChat() {

        const chatBox = document.getElementById("aiChatBox");

        chatBox.style.display = "flex";

        document.getElementById("aiQuestion").focus();
    }


    function closeAIChat() {

        document.getElementById("aiChatBox").style.display = "none";
    }


    function handleAIEnter(event) {

        if (event.key === "Enter") {
            askAI();
        }
    }


    async function askAI() {

        const input = document.getElementById("aiQuestion");
        const messages = document.getElementById("aiMessages");

        const question = input.value.trim();

        if (!question) {
            return;
        }

        const sendButton = document.getElementById("aiSendButton");


        // Show user message

        const userMessage = document.createElement("div");

        userMessage.className = "user-message";

        userMessage.textContent = question;

        messages.appendChild(userMessage);


        // Clear input

        input.value = "";


        // Scroll down

        messages.scrollTop = messages.scrollHeight;


        // Show thinking message

        const thinkingMessage = document.createElement("div");

        thinkingMessage.className = "ai-message";

        thinkingMessage.textContent = "Jawab taiyaar ho raha hai...";

        messages.appendChild(thinkingMessage);
        sendButton.disabled = true;


        try {

           const response = await fetch("/api/assistant/ask", {
               method: "POST",
               headers: { "Content-Type": "application/json" },
               body: JSON.stringify({ question })
           });


            if (!response.ok) {

                throw new Error("Server error");
            }


            const answer = await response.text();


            thinkingMessage.textContent = answer;


        } catch (error) {

            thinkingMessage.textContent =
                "Abhi jawaab nahi mil saka. Thodi der baad phir koshish kijiye.";

            console.error(error);
        } finally {
            sendButton.disabled = false;
            input.focus();
        }


        messages.scrollTop = messages.scrollHeight;
    }

</script>

<!-- ================= END AI ASSISTANT ================= -->
