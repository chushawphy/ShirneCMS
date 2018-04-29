<?php
/**
 * Created by IntelliJ IDEA.
 * User: shirn
 * Date: 2018/4/15
 * Time: 18:40
 */

namespace app\api\model;

use think\facade\Log;
use think\Model;

class TokenModel extends Model
{
    private $hash='sw4GomU4LXvYqcaLctXCLK43eRcob';
    private $expire=720;

    protected $autoWriteTimestamp = true;

    protected function getToken($memid,$hash=''){
        if(empty($hash))$hash=$this->hash;
        return md5($hash.date('YmdHis').microtime().str_pad($memid,11));
    }
    protected function mapToken($data,$response=true){
        $token = array(
            'member_id'=>$data['member_id'],
            'token'=>$data['token'],
            'expire_in'=>$data['expire_in'],
            'refresh_token'=>$data['refresh_token']
        );
        if(!$response)$token['member_id']=$data['member_id'];
        return $token;
    }
    public function findToken($token){
        $token=$this->where(array('token'=>$token))->find();
        if(empty($token)){
            return false;
        }
        return $this->mapToken($token,false);
    }
    public function createToken($member_id){
        $token=$this->where(array('member_id'=>$member_id))->find();
        $data=array(
            'token'=>$this->getToken($member_id),
            'expire_in'=>$this->expire
        );
        $data['refresh_token']=$this->getToken($member_id,str_shuffle($data['token']));
        if(empty($token)){
            $data['member_id']=$member_id;
            $added=$this->insert($data);
            if(!$added){
                Log::write('Token insert error:'.$this->getError());
            }
        }else{
            $this->where(array('member_id'=>$member_id))->save($data);
        }
        return $this->mapToken($this->where(array('member_id'=>$member_id))->find());
    }
    public function refreshToken($refresh){
        $token=$this->where(array('refresh_token'=>$refresh))->find();
        if(empty($token)){
            return false;
        }

        $data=array(
            'token'=>$this->getToken($token['member_id']),
            'expire_in'=>$this->expire
        );
        $data['refresh_token']=$this->getToken($token['member_id'],str_shuffle($data['token']));

        $this->where(array('member_id'=>$token['member_id']))->save($data);

        return $this->mapToken($this->where(array('member_id'=>$token['member_id']))->find());
    }
}