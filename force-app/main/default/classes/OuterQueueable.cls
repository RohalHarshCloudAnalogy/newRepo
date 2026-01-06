public class OuterQueueable implements Queueable {
    public void execute(QueueableContext context) {
        System.debug('--- Outer Queueable ---');
        System.debug('Outer Current Depth: ' + AsyncInfo.getCurrentQueueableStackDepth());
        System.debug('Outer Max Depth: ' + AsyncInfo.getMaximumQueueableStackDepth());

        System.enqueueJob(new InnerQueueable());
    }
}