import socket
import socketserver
from NLPunit import NLPunit as nlp
from pattern.text.en import singularize
from word2number import w2n

class MyTCPHandler(socketserver.StreamRequestHandler):
    nlp = nlp()

    def handle(self):
        data = str(self.rfile.readline(), 'utf-8')
        product = self.nlp.extract_product(data)
        quantity = self.nlp.extract_quantity(data)
        unit = self.nlp.extract_unit(data, product, quantity)

        if product:
            product = singularize(product)
        if quantity:
            quantity = str(w2n.word_to_num(quantity))
        if unit:
            unit = singularize(unit)
        else:
            unit = "null"

        print("product:" + product + " quantity:" + quantity + " unit:" + unit)
        self.wfile.write(bytes((product + ',' + quantity + ',' + unit), 'utf-8'))

if __name__ == "__main__":
    PORT = 1337
    HOST  = socket.gethostbyname(socket.gethostname())

    with socketserver.TCPServer(('192.168.2.11', PORT), MyTCPHandler) as server:
        server.serve_forever()





