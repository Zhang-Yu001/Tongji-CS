class User implements Observer {
    private String name;

    public User(String name) {
        this.name = name;
    }

    public void update(String status) {
        System.out.println("User " + name + " notified. New Order Status: " + status);
    }
}
