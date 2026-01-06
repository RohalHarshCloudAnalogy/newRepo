public class FutureToQueueableExample {

    @future
    public static void callQueueableFromFuture() {
        System.debug('Inside future method');

        // Enqueueing Queueable job
        System.enqueueJob(new newQueueable());
    }
}