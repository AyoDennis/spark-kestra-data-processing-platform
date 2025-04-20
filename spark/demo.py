import os
from dotenv import load_dotenv

load_dotenv()

# acess = os.getenv("ACCESS_KEYS")
# print(acess)

# sec = os.getenv("SECRET_ACCESS_KEY")

# print(sec)

first = os.getenv("FIRST_NAME")
last = os.getenv("LAST_NAME")
combine = os.getenv("COMBINE")


print(first)
print(last)
print(combine)

# print(os.environ)