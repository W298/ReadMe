import pytesseract

def tes(filename):
    return pytesseract.image_to_string(filename, lang = 'kor')
