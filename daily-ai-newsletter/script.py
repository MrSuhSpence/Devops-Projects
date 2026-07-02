import os
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import requests
from google import genai

# Initialize the Gemini Client
client = genai.Client()

def generate_content():
    prompt = (
        "Provide two distinct sections. "
        "Section 1: A clean, funny daily IT or DevOps tech joke. "
        "Section 2: A highly practical tech skill, Linux command, or automation concept to learn today with a 2-sentence explanation."
    )
    
    # Updated to a modern, supported model name
    response = client.models.generate_content(
        model='gemini-2.5-flash',
        contents=prompt,
    )
    return response.text

def get_meme_url():
    try:
        response = requests.get("https://meme-api.com/gimme").json()
        return response.get("url", "")
    except Exception:
        return "https://i.imgflip.com/1bij.jpg"

def send_email(content, meme_url):
    sender_email = os.environ.get("SENDER_EMAIL")
    sender_password = os.environ.get("SENDER_PASSWORD")
    receiver_email = os.environ.get("RECEIVER_EMAIL")

    msg = MIMEMultipart('alternative')
    msg['Subject'] = "Your Daily DevOps Digest & Meme"
    msg['From'] = sender_email
    msg['To'] = receiver_email

    html = f"""
    <html>
      <body>
        <h2>Daily Tech Stack Update</h2>
        <p style="white-space: pre-wrap;">{content}</p>
        <hr>
        <h3>Your Daily Meme:</h3>
        <img src="{meme_url}" alt="Meme" style="max-width:500px;">
      </body>
    </html>
    """
    msg.attach(MIMEText(html, 'html'))

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, receiver_email, msg.as_string())

if __name__ == "__main__":
    print("Generating AI content...")
    ai_text = generate_content()
    
    print("Fetching meme...")
    meme = get_meme_url()
    
    print("Sending email...")
    send_email(ai_text, meme)
    print("Pipeline executed successfully!")
