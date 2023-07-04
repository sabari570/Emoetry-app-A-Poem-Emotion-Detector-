from flask import Flask, request, jsonify
import joblib
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize, sent_tokenize
from nltk.stem import PorterStemmer
import re
import string

stop_words = stopwords.words('english')
stemmer = PorterStemmer()
punct = string.punctuation
emotions = ['love', 'sad', 'anger', 'hate', 'fear', 'surprise', 'courage', 'joy', 'peace', "hope", 'care']

encoding_result = {0: 'love',
                   1: 'sad',
                   2: 'anger',
                   3: 'hate',
                   4: 'fear',
                   5: 'surprise',
                   6: 'courage',
                   7: 'joy',
                   8: 'peace',
                   9: 'hope',
                   10: 'care'}


def remove_endline(text):
    cleaned_stanza = []
    for line in text.split('\n'):
        cleaned_stanza.append(line)
    return ' '.join(cleaned_stanza)


def text_cleaning(text):
    # Removing endlines
    text = remove_endline(text)
    # Lowercasing the text
    text = text.lower()
    # Removing punctuations
    text = text.translate(str.maketrans('', '', punct))
    # Removing numbers from text
    text = re.sub('[0-9]', '', text)
    # Tokenizing the text
    tokens = [w for w in word_tokenize(text)]
    # Removing stopwords
    cleaned_text = [w for w in tokens if w not in stop_words]
    return ' '.join(cleaned_text)


app = Flask(__name__)

vectorizer = joblib.load("vectorizer.joblib")
model = joblib.load("MLModel.joblib")


@app.route("/index")
def index():
    return 'Hello Sabari!!'


@app.route('/predict_poem_emotion', methods=['POST'])
def predict_poem_emotion():
    data = request.get_json(force=True)
    text = data['stanza']
    line_tfidf = vectorizer.transform([text_cleaning(text)])
    line_emotion = encoding_result[model.predict(line_tfidf)[0]]
    return jsonify(
        emotion=line_emotion
    )


if __name__ == '__main__':
    app.run(debug=True, port=4000)
