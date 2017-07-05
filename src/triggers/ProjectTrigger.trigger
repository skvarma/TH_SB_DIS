trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    if (Trigger.isAfter && Trigger.isUpdate) {
        BillingCalloutService billingCalloutService = new BillingCalloutService();
        billingCalloutService.callBillingService(Trigger.new, Trigger.oldMap);
    }

}