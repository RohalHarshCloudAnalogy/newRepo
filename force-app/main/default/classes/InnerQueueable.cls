public class InnerQueueable implements Queueable {
    public void execute(QueueableContext context) {
        System.debug('--- Inner Queueable ---');
        System.debug('Inner Current Depth: ' + AsyncInfo.getCurrentQueueableStackDepth());
        System.debug('Inner Max Depth: ' + AsyncInfo.getMaximumQueueableStackDepth());
    }
}