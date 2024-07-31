abstract class ProductDecorator implements Product {
    protected Product decoratedProduct;

    public ProductDecorator(Product decoratedProduct) {
        this.decoratedProduct = decoratedProduct;
    }

    public String getDescription() {
        return decoratedProduct.getDescription();
    }

    public double getPrice() {
        return decoratedProduct.getPrice();
    }
}
