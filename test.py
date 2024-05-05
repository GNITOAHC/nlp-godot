import asyncio
import websockets
import time
import base64
import requests

api_key = "sk-proj-GQCFnuD6AJmYkX5WeIvhT3BlbkFJ00Ak7VrS10wvp9Y77RXX"
img_path = "C:/Users/chaot/Downloads/image.png"
cmd = ["move_right", "move_left", "jump", "stop"]
headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {api_key}"
}

def get_payload(base64_img):
    payload = {
      "model": "gpt-4-turbo",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": "This is a 2D Pixel game image. Please tell me if I need to go either right, left, jump or stop. Response with a single word, either right, left, jump or stop."
            },
            {
              "type": "image_url",
              "image_url": {
                "url": f"data:image/jpeg;base64,{base64_img}"
              }
            }
          ]
        }
      ],
      "max_tokens": 100
    }
    return payload

# Function to encode the image
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

base64_img = encode_image(img_path)
response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=get_payload(base64_img))
# print(response.json().choices[0].message.content)
data = dict(response.json())
print(data["choices"][0]["message"]["content"])
# print(data.choices[0].message)
