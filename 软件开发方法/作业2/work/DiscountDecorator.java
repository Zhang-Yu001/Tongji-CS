class DiscountDecorator extends ProductDecorator {
    private double discount;

    public DiscountDecorator(Product decoratedProduct, double discount) {
        super(decoratedProduct);
        this.discount = discount;
    }

    public String getDescription() {
        return decoratedProduct.getDescription() + " with discount";
    }

    public double getPrice() {
        return decoratedProduct.getPrice() * (1 - discount);
    }
}
