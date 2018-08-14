public class MyUserType{
    public String userType {set;get;}
    public MyUserType(){
        userType = UserInfo.getuserType();
    }
    public MyUserType(vlocity_ins.VFCustomChildListController v){
    userType = UserInfo.getuserType();
    }
}