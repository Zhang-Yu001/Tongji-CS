public class DecoratorPatternDemo {
    public static void main(String[] args) {
        Product basicProduct = new BasicProduct("Basic Product", 100.0);
        Product discountedProduct = new DiscountDecorator(basicProduct, 0.1);

        System.out.println(basicProduct.getDescription() + ": $" + basicProduct.getPrice());
        System.out.println(discountedProduct.getDescription() + ": $" + discountedProduct.getPrice());
    }
}
