from tika import parser
import math
import flask
from flask import request, jsonify, session
from flask_session import Session


class Tupla:
    def __init__(self, word):
        self._word = word

    def get_nome(self):
        return self._word

    def set_nome(self, word):
        self._word = word


class Table:
    def __init__(self, pages=[], firstPage=0):
        self._pages = pages
        self.firstPage = firstPage

    def get_pages(self):
        return self._pages

    def set_pages(self, pages):
        self._pages = pages

    def get_firstPage(self):
        return self.firstPage


class Bucket:
    def __init__(self, tuplas=[], nextBucket=None, size=0, colision=0, overflow=0, value=0):
        self._tuplas = tuplas
        self._nextBucket = nextBucket
        self.size = size
        self.colision = colision
        self.overflow = overflow
        self.value = value

    def get_tuplas(self):
        return self._tuplas

    def add(self, tupla):
        self._tuplas.append(tupla)
        self.set_size()
        self.set_colision()

    def get_nextBucket(self):
        return self._nextBucket

    def set_nextBucket(self, bucket):
        self._nextBucket = bucket
        self.set_overflow()

    def get_size(self):
        return self.size

    def set_size(self):
        self.size += 1

    def get_value(self):
        return self.value

    def set_value(self, value):
        self.value = value

    def get_colision(self):
        return self.colision

    def set_colision(self):
        self.colision += 1

    def get_overflow(self):
        return self.overflow

    def set_overflow(self):
        self.overflow += 1


class Page:
    def __init__(self, id=0, tuplas=[], size=0, nextPage=None):
        self.tuplas = tuplas
        self._id = id
        self.size = size
        self.nextPage = nextPage

    def get_tuplas(self):
        return self.tuplas

    def set_tuplas(self, tuplas):
        self.tuplas = tuplas
        self.size += 1

    def get_id(self):
        return self._id

    def set_id(self, id):
        self._id = id

    def get_size(self):
        return self._id

    def get_nextPage(self):
        return self.nextPage

    def set_nextPage(self, page):
        self.nextPage = page


class Database:
    def __init__(self, table, buckets):
        self.table = table
        self.buckets = buckets

    def get_buckets(self):
        return self.buckets


def hash(tupla):
    h = 0
    aux = list(tupla)
    for x in aux:
        h += ord(x)
    return int(str(h)[:3])


def next(bucket, bucketLimit, tupla, buckets):
    if(bucket.get_size() < bucketLimit):
        bucket.add(tupla)
    else:
        if(bucket.get_nextBucket() != None):
            next(bucket.get_nextBucket(), bucketLimit, tupla, buckets)
        else:
            nextbucket = Bucket([tupla], None, 1, 0, 0, bucket.get_value())
            bucket.set_nextBucket(nextbucket)


def busca(i, count, value):
    for x in i.get_tuplas():
        count += 1
        if x.get_nome() == value:
            return True,count
    if i.get_nextBucket() != None:
        helpBusca(i.get_nextBucket(), count)
    else:
        return False, count


def helpBusca(i, count):
    for x in i.get_tuplas():
        count += 1
        if x.get_nome() == value:
            return true,count
    if i.get_nextBucket() != None:
        helpBusca(i.get_nextBucket(), count)
    else:
        return false,count


def createDB(bucketLimit, size):
    raw = parser.from_file('words.txt')
    lines = raw['content'].split()

    tuplas = []
    id = 0
    cont = 0
    countRegistro = 0
    pages = []
    page = Page()
    for l in lines:
        countRegistro += 1
        cont += 1
        tupla = Tupla(l)
        tuplas.append(tupla)
        if(size == cont):
            page.set_tuplas(tuplas)
            page.set_id(id)
            id += 1
            cont = 0
            pages.append(page)
            page = Page()
            tuplas = []

    if(cont > 0):
        page.set_tuplas(tuplas)
        page.set_id(id)
        pages.append(page)

    buckets = [None] * 1000

    for page in pages:
        for tupla in page.get_tuplas():
            v = hash(tupla.get_nome())
            if(buckets[v] != None):
                next(bucket, bucketLimit, tupla, buckets)
            else:
                bucket = Bucket([tupla], None, 1, 0, 0, v)
                buckets[v] = bucket

    table = Table(pages, 0)
    database = Database(table, buckets)
    somaColisoes = 0
    somaOverflow = 0
    for o in buckets:
        if o != None:
            somaColisoes += o.get_colision()
            somaOverflow += o.get_overflow()

    return somaColisoes, somaOverflow, countRegistro, len(buckets), bucketLimit, size, database


def find(value, database):
    h = hash(value)
    contador = 0
    print(database.get_buckets()[h].get_tuplas()[0])
    x, cout = busca(database.get_buckets()[h], contador, value)
    return x, cout


app = flask.Flask(__name__)
SESSION_TYPE = 'filesystem'
app.config.from_object(__name__)
app.config["DEBUG"] = True
Session(app)


@app.route('/config', methods=['POST'])
def home():

    limit = request.get_json()['limit']
    pageSize = request.get_json()['page_size']
    somaColisoes, somaOverflow, countRegistro, buckets, bucketLimit, size, database = createDB(
        limit, pageSize)
    session['key'] = database
    return jsonify({
        'colisions': somaColisoes,
        'overflow': somaOverflow,
        'countRegistro': countRegistro,
        'buckets': buckets,
        'bucketLimit': bucketLimit,
        'size': size
    }), 201


@app.route('/busca', methods=['POST'])
def busca_request():

    value = request.get_json()['value']
    a = session.get('key', 'not set')
    x, contador = find(value, a)
    return jsonify({'access': contador,
                    'found': x
                    }), 201


app.run()


# print(buckets[2].get_tuplas()[2].get_nome())
