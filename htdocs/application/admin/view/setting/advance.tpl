<extend name="Public:Base" />

<block name="body">

<include file="Public/bread" menu="setting_index" section="系统" title="配置管理" />

<div id="page-wrapper">

    <div class="row">
        <div class="col-md-6">
            <a href="{:U('setting/index')}" class="btn btn-primary">普通模式</a>&nbsp;&nbsp;
            <a href="{:U('setting/add')}" class="btn btn-success">添加配置</a>
        </div>
        <div class="col-md-6">
            <form action="{:U('setting/advance')}" method="post">
                <div class="form-group input-group">
                    <input type="text" class="form-control" name="key" value="{$key}" placeholder="输入字段名或者描述关键词搜索">
                    <span class="input-group-btn">
                      <button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button>
                    </span>
                </div>
            </form>
        </div>
    </div>
    <table class="table table-hover table-striped">
        <thead>
            <tr>
                <th width="50">编号</th>
                <th>标题</th>
                <th>字段</th>
                <th>分组</th>
                <th>类型</th>
                <th>说明</th>
                <th width="150">操作</th>
            </tr>
        </thead>
        <tbody>
        <foreach name="model" item="v">
            <tr>
                <td>{$v.id}</td>
                <td>{$v.title}</td>
                <td>{$v.key}</td>
                <td>{$v.group|settingGroups}</td>
                <td>{$v.type|settingTypes}</td>
                <td>{$v.description}</td> 
                <td>
                    <a class="btn btn-default btn-sm" href="{:U('setting/update',array('id'=>$v['id']))}"><i class="fa fa-edit"></i> 编辑</a>
                    <a class="btn btn-default btn-sm" href="{:U('setting/delete',array('id'=>$v['id']))}" style="color:red;" onclick="javascript:return del('您真的确定要删除吗？\n\n删除后将不能恢复!');"><i class="fa fa-trash"></i> 删除</a>
                </td>
            </tr>
        </foreach>
        </tbody>
    </table>
    {$page}
</div>

</block>