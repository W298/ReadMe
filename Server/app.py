from flask import Flask, request
import numpy
import cv2
import pagedewarp
import tes
import tts
import base64
from PIL import Image
import os
from flask_restful import Resource, Api, reqparse

app = Flask(__name__)
api = Api(app)

class GetChar(Resource):
    def post(self):

        r = request

        nparr = numpy.fromstring(r.data, numpy.uint8)

        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        name = "Test"
        imgname = pagedewarp.main(img, name)

        text = tes.tes(imgname)

        tts.ConvertToAudio(text, "M")

class Base64Image(Resource):
    def post(self):

        encoded_audio = ""

        # Get Base64 Image
        parser = reqparse.RequestParser()
        parser.add_argument('image', type=str)
        parser.add_argument('date', type=str)
        parser.add_argument('gender', type=str)

        args = parser.parse_args()

        image_b64 = args['image']
        date = args['date']
        gender = args['gender']

        # Write Image
        with open("img_np/{0}_ori.png".format(date), 'wb') as f:
            f.write(base64.b64decode(image_b64))

        # Rotate and Save Image
        img_notrot = Image.open("img_np/{0}_ori.png".format(date))
        img_rot = img_notrot.transpose(Image.ROTATE_270)

        img_rot.save("img_np/{0}.png".format(date))
        os.remove("img_np/{0}_ori.png".format(date))

        print("Image Recieve Process Done / {0}.png (1/5)".format(date))

        # Process Dewarp Algo.
        cvimg = cv2.imread("img_np/{0}.png".format(date))

        imgpath = pagedewarp.main(cvimg, date)

        print("Dewarp Process Done / {0}.png (2/5)".format(date))

        # Process Tesseract Algo.
        text = tes.tes(imgpath)

        print("Tesseract Process Done / {0}.png (3/5)".format(date))

        # Convert to Audio
        tts.ConvertToAudio(text, gender)

        print("Convert to Audio Process Done / {0}.png (4/5)".format(date))

        # Send to Client
        with open("output.mp3", "rb") as f1:
            encodedaudio = base64.b64encode(f1.read())

        return {"audio" : str(encodedaudio)}

api.add_resource(GetChar, '/getchar')
api.add_resource(Base64Image, '/base64img')

if __name__ == '__main__':
    app.run(host="10.146.0.6", port=5000)



