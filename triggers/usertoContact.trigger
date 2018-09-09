trigger usertoContact on User (after insert) {
    usertocontact.usertocon(Trigger.newMap.keySet());

}