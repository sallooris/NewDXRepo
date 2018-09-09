trigger NewContactOnUser on User (After insert) {
 usertocontact.usertocon();
}