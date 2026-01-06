trigger LeadWithZapier on Lead (before insert,After delete) {
    for(lead l : Trigger.old){
        ZapierOutbound.sendDeleteNotification(l.Id, l.Email);
    }
}