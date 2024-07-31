public class SingletonPatternDemo {
    public static void main(String[] args) {
        DatabaseConnector connector1 = DatabaseConnector.getInstance();
        DatabaseConnector connector2 = DatabaseConnector.getInstance();

        System.out.println("HashCode of connector1: " + connector1.hashCode());
        System.out.println("HashCode of connector2: " + connector2.hashCode());
    }
}
