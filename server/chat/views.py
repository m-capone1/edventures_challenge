from rest_framework import generics
from rest_framework.response import Response
from rest_framework import status
import os
from openai import OpenAI
from .serializers import ChatMessageSerializer
from dotenv import load_dotenv

load_dotenv()

class ChatView(generics.CreateAPIView):
    serializer_class = ChatMessageSerializer

    def post(self, request, *args, **kwargs):
        user_message = request.data.get("message")

        if not user_message:
            return Response({"error": "Message is required"}, status=status.HTTP_400_BAD_REQUEST)
    
        api_key = os.environ.get("OPENAI_API_KEY")
        client = OpenAI(api_key=api_key)

        print(api_key)

        try:
            chat_completion = client.chat.completions.create(
                messages=[
                    {
                        "role": "user",
                        "content": user_message,
                    }
                ],
                model="gpt-3.5-turbo",
            )
            bot_response = chat_completion.choices[0].message.content

            return Response({"message": user_message, "response": bot_response}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
