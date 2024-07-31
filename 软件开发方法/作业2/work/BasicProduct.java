class BasicProduct implements Product {
    private String description;
    private double price;

    public BasicProduct(String description, double price) {
        this.description = description;
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }
}
