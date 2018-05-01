<?php
/**
 * Created by IntelliJ IDEA.
 * User: shirne
 * Date: 2018/4/30
 * Time: 10:23
 */

namespace app\admin\validate;


use app\common\validate\BaseUniqueValidate;

class CategoryValidate extends BaseUniqueValidate
{
    protected $rule=array(
        'title'=>'require',
        'short'=>'max:20',
        'name'=>'require|unique:category,%id%'
    );
    protected $message=array(
        'title.require'=>'请填写分类标题',
        'name.require'=>'请填写分类别名',
        'name.unique'=>'分类别名已存在',
        'short.max'=>'简称长度不能超过20'
    );
}