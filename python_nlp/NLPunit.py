from transformers import pipeline

class NLPunit:
    nlp = pipeline("question-answering")
    

    def extract_product(self, context):
        result = self.nlp(question="what product?", context=context)
        return result.get('answer').lower()

    def extract_quantity(self, context):
        result = self.nlp(question="what number?", context=context)
        return result.get('answer').lower()

    def extract_unit(self, context, product, quantity):
        result = self.nlp(question="how much?", context=context)
        return result.get('answer').lower().replace(product, '').replace(quantity, '').replace(' ', '').replace('of', '')

