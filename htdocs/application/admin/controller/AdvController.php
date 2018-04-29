<?php
/**
 * 广告功能
 * User: shirne
 * Date: 2018/4/17
 * Time: 8:36
 */

namespace app\admin\controller;


use think\Db;

class AdvController extends BaseController
{
    public function index(){
        $model = Db::name('AdvGroup');
        $where=array();
        if(!empty($key)){
            $where['title'] = array('like',"%$key%");
            $where['flag'] = array('like',"%$key%");
            $where['_logic'] = 'or';
        }
        $this->pagelist($model,$where,'id DESC');
        $this->display();
    }

    /**
     * 添加/修改
     */
    public function update($id=0)
    {
        $id = intval($id);

        if ($this->request->isPost()) {
            $model = Db::name("AdvGroup");
            if (!$model->create()) {
                $this->error($model->getError());
            }else{
                if($id==0){
                    if ($model->add()) {
                        $this->success("添加成功", url('adv/index'));
                    } else {
                        $this->error("添加失败");
                    }
                }else {
                    if ($model->save()) {
                        $this->success("更新成功", url('adv/index'));
                    } else {
                        $this->error("更新失败");
                    }
                }
            }
        }else{
            if($id!=0) {
                $model = Db::name('AdvGroup')->where("id= %d", $id)->find();
            }else{
                $model=array('status'=>1);
            }
            $this->assign('model',$model);
            $this->display();
        }
    }
    /**
     * 删除广告位
     */
    public function delete($id)
    {
        $id = intval($id);
        $force=$this->request->post('force/d',0);
        $model = Db::name('AdvGroup');
        $count=Db::name('AdvItem')->where(array('group_id'=>$id))->count();
        if($count<1 || $force!=0) {
            $result = $model->delete($id);
        }else{
            $this->error("广告位中还有广告项目");
        }
        if($result){
            if($count>0){
                Db::name('AdvItem')->where(array('group_id'=>$id))->delete();
            }
            $this->success("广告位删除成功", url('adv/index'));
        }else{
            $this->error("广告位删除失败");
        }
    }

    public function itemlist($gid){
        $model = Db::name('AdvItem');
        $group=Db::name('AdvGroup')->find($gid);
        if(empty($group)){
            $this->error('广告位不存在');
        }
        $where=array('group_id'=>$gid);
        if(!empty($key)){
            $where['title'] = array('like',"%$key%");
            $where['url'] = array('like',"%$key%");
            $where['_logic'] = 'or';
        }
        $this->pagelist($model,$where,'id DESC');
        $this->assign('gid',$gid);
        $this->display();
    }

    /**
     * 添加/修改
     */
    public function itemupdate($id=0,$gid=0)
    {
        $id = intval($id);
        $url=$gid==0?url('adv/index'):url('adv/itemlist',array('gid'=>$gid));
        if ($this->request->isPost()) {
            $model = Db::name("AdvItem");
            if (!$model->create()) {
                $this->error($model->getError());
            }else{
                if($id==0){
                    if ($model->insert()) {
                        $this->success("添加成功",$url);
                    } else {
                        $this->error("添加失败");
                    }
                }else {
                    if ($model->update()) {
                        $this->success("更新成功", $url);
                    } else {
                        $this->error("更新失败");
                    }
                }
            }
        }else{
            if($id!=0) {
                $model = Db::name('AdvItem')->where("id= %d", $id)->find();
            }else{
                $model=array('status'=>1);
            }
            $this->assign('gid',$gid);
            $this->assign('model',$model);
            $this->display();
        }
    }
    /**
     * 删除广告位
     */
    public function itemdelete($gid,$id)
    {
        $id = intval($id);
        $model = Db::name('AdvItem');
        $result = $model->delete($id);
        if($result){
            $this->success("广告删除成功", url('adv/itemlist',array('gid'=>$gid)));
        }else{
            $this->error("广告删除失败");
        }
    }
}