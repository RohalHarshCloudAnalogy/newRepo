public class newQueueable implements Queueable {
    public void execute(QueueableContext context) {
        System.enqueuejob(new newQueueable());
    }
}