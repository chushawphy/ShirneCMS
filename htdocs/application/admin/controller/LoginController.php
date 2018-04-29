<?php
namespace app\admin\controller;
use think\Controller;
use think\Db;

class LoginController extends Controller {

    //登陆主页
    public function index(){
        $this->display();
    }
    //登陆验证
    public function login(){
        if(!$this->request->isPost())$this->error("非法请求");
        $member = Db::name('Manager');
        $username =$this->request->post('username','','trim');
        $password =$this->request->post('password');
        $code = $this->request->post('verify','','strtolower');
        //验证验证码是否正确
        if(!($this->check_verify($code))){
            $this->error('验证码错误');
        }
        //验证账号密码是否正确
        $user = $member->where(array('username'=>$username))->find();

        if(empty($user) || $user['password'] !== encode_password($password,$user['salt'])) {
            if(!empty($user)){
                //登录日志
                user_log($user['id'],'login',0,'密码错误:'.$password,'manager');
            }
            $this->error('账号或密码错误 :(') ;
        }

        //验证账户是否被禁用
        if($user['status'] == 0){
            user_log($user['id'],'login',0,'账号已禁用' ,'manager');
            $this->error('账号被禁用，请联系超级管理员 :(') ;
        }

        setLogin($user);

        $this->success("登陆成功",url('Index/index'));
    }

    //验证码
    public function verify(){
        $Verify = new \think\captcha\Captcha();
        $Verify->codeSet = '0123456789';
        $Verify->fontSize = 13;
        $Verify->length = 4;
        $Verify->entry();
    }
    protected function check_verify($code){
        $verify = new \think\captcha\Captcha();
        return $verify->check($code);
    }

    public function logout(){
        clearLogin();
    }
}