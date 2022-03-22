from tika import parser
import math
import flask
from flask import request, jsonify


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
    h /= 3
    return round(h)


def next(bucket, bucketLimit, tupla, buckets):
    if(bucket.get_size() < bucketLimit):
        bucket.add(tupla)
    else:
        if(bucket.get_nextBucket() != None):
            next(bucket.get_nextBucket(), bucketLimit, tupla, buckets)
        else:
            nextbucket = Bucket([tupla], None, 1, 0, 0, bucket.get_value())
            bucket.set_nextBucket(nextbucket)


def busca(value, buckets):
    hashBusca = hash(value)
    count = 0
    for i in buckets:
        count += 1
        helpBusca(hashBusca, i, count, value)
    return count


def helpBusca(hashBusca, i, count, value):
    if hashBusca == i.get_value():
        for x in i.get_tuplas():
            count += 1
            if x.get_nome() == value:
                print("achou a tupla")
        if i.get_nextBucket() != None:
            helpBusca(hashBusca, i.get_nextBucket(), count, value)


def createDB(bucketLimit, size, value):
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

    buckets = []

    for page in pages:

        for tupla in page.get_tuplas():
            newb = True
            v = hash(tupla.get_nome())
            for bucket in buckets:
                if(bucket.get_value() == v):
                    newb = False
                    next(bucket, bucketLimit, tupla, buckets)

            if(newb):
                bucket = Bucket([tupla], None, 1, 0, 0, v)
                buckets.append(bucket)

    table = Table(pages, 0)
    database = Database(table, buckets)
    x = busca(value, database.get_buckets())
    somaColisoes = 0
    somaOverflow = 0
    for o in buckets:
        somaColisoes += o.get_colision()
        somaOverflow += o.get_overflow()

    return x, somaColisoes, somaOverflow, countRegistro, len(buckets), bucketLimit, size


app = flask.Flask(__name__)
app.config["DEBUG"] = True


@app.route('/busca', methods=['POST'])
def home():

    value = request.get_json()['value']
    limit = request.get_json()['limit']
    pageSize = request.get_json()['page_size']
    x, somaColisoes, somaOverflow, countRegistro, buckets, bucketLimit, size = createDB(
        limit, pageSize, value)
    return jsonify({'access': x,
                    'colisions': somaColisoes,
                    'overflow': somaOverflow,
                    'countRegistro': countRegistro,
                    'buckets': buckets,
                    'bucketLimit': bucketLimit,
                    'size': size
                    }), 201


app.run()


# print(buckets[2].get_tuplas()[2].get_nome())
