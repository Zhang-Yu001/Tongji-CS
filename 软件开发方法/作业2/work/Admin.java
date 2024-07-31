class Admin implements Observer {
    private String name;

    public Admin(String name) {
        this.name = name;
    }

    public void update(String status) {
        System.out.println("Admin " + name + " notified. New Order Status: " + status);
    }
}
