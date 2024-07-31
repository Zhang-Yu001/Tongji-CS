public class ObserverPatternDemo {
    public static void main(String[] args) {
        Order order = new Order();

        User user1 = new User("Alice");
        User user2 = new User("Bob");
        Admin admin = new Admin("Admin1");

        order.attach(user1);
        order.attach(user2);
        order.attach(admin);

        order.setStatus("Shipped");

        order.detach(user2);

        order.setStatus("Delivered");
    }
}
