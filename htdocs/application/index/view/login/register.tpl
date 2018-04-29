<extend name="Public:Base" />

<block name="body">


	<div class="main">

		<div class="container register">
			<fieldset>
				<legend>会员注册</legend>
				<blockquote>
					<h3>创建一个账户</h3>
					<p>请填写您的注册账户信息，用于登录。</p>
				</blockquote>
				<div class="panel-body">

					<form class="form-horizontal registerForm" role="form" method="post" action="{:U('Login/register')}">
						<div class="form-group">
							<label for="userName" class="col-sm-2 control-label">用户名：</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" name="username"><br/>
								<span class="remind">用户名以6—10位数字和字母组成 <i>*</i></span>
							</div>
						</div>
						<div class="form-group">
							<label for="Password" class="col-sm-2 control-label">密码：</label>
							<div class="col-sm-10">
								<input type="password" class="form-control" name="password"><br/>
								<span class="remind">密码以6—20位字符，可包含大小写字母，数字及特殊符号<i>*</i></span>
							</div>
						</div>
						<div class="form-group">
							<label for="Password" class="col-sm-2 control-label">确认密码：</label>
							<div class="col-sm-10">
								<input type="password" class="form-control" name="repassword"><br/>
								<span class="remind">请再次确认您输入的密码<i>*</i></span>
							</div>
						</div>
						<div class="form-group">
							<label for="realName" class="col-sm-2 control-label">真实姓名：</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" name="realname"><br/>
								<span class="remind">真实姓名填写无法更改，必须与提款银行账户一致,否则无法提款<i>*</i></span>
							</div>
						</div>
						<div class="form-group">
							<label for="email" class="col-sm-2 control-label">邮箱地址：</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" name="email"><br/>
								<span class="remind">合法邮箱地址：abc@def.com<i>*</i></span>
							</div>
						</div>
						<div class="form-group">
							<label for="mobile" class="col-sm-2 control-label">手机号码：</label>
							<div class="col-sm-10">
								<if condition="0">
								<div class="input-group">
									<input type="text" class="form-control" name="mobile">
									<a class="btn btn-default input-group-addon">发送验证码</a>
									<input type="text" class="form-control" name="mobilecheck">
								</div>
									<else/>
									<input type="text" class="form-control" name="mobile">
								</if><br/>
								<span class="remind">请填写11位手机号码<i>*</i></span>
							</div>
						</div>
						<if condition="$nocode">
							<else/>
						<div class="form-group">
							<label for="mobile" class="col-sm-2 control-label">激活码：</label>
							<div class="col-sm-10">
								<input type="text" class="form-control" name="invite_code"><br/>
								<span class="remind">您的推荐人提供给你的激活码<if condition="$config['m_invite'] eq 2"><i>*</i></if></span>
							</div>
						</div>
						</if>
						<div class="form-group submitline">
							<div class="col-sm-offset-2 col-sm-10">
								<button type="submit" class="btn btn-default create">创建我的账户</button>
							</div>
						</div>
					</form>

				</div>
			</fieldset>
		</div>
	</div>
	<script type="text/javascript">
		jQuery(function($){
			$('.registerForm').submit(function(e) {
				e.preventDefault();
				e.stopPropagation();
				
				var username=$(this).find('[name=username]').val();
				if(username=='')return $(this).find('[name=username]').trigger('blur').focus();

				var password=$(this).find('[name=password]').val();
				if(password=='')return $(this).find('[name=password]').trigger('blur').focus();

				var realname=$(this).find('[name=realname]').val();
				if(realname=='')return $(this).find('[name=realname]').trigger('blur').focus();

				var email=$(this).find('[name=email]').val();
				if(email=='')return $(this).find('[name=email]').trigger('blur').focus();

				var mobile=$(this).find('[name=mobile]').val();
				if(mobile=='')return $(this).find('[name=mobile]').trigger('blur').focus();

                if ('{$config["m_invite"]}' == '2') {
                    var invite_code = $(this).find('[name=invite_code]').val();
                    if (invite_code == '') return $(this).find('[name=invite_code]').trigger('blur').focus();
                }

				if($(this).find('.error').length>0){
					return alert('请按要求填写表单');
				}else {
					$.ajax({
						url: $(this).attr('action'),
						data: $(this).serialize(),
						dataType: 'JSON',
						type: 'POST',
						success: function (j) {
							if (j.status == 0) {
								alert(j.info);
							} else {
								alert('注册成功！');
								location.href = j.url;
							}
						}
					});
				}
			});
			var ajaxtime=new Object();
			$('.registerForm .form-control').blur(function() {
				var val=$(this).val(),form=$(this.form);
				var error='',fname=this.name,self=this;
				var time=new Date().getTime();
				switch (fname){
					case 'username':
						if(val=='') {
							error = '请填写用户名';
						}else if(!val.match(/^[a-zA-Z][a-zA-Z0-9\-]{5,9}$/)) {
							error = '用户名必须由字母和数字且6-10位';
						}else{
							ajaxtime[fname]=new Date().getTime();
							$.ajax({
								url:'{:U('Login/checkunique',array('type'=>'username'))}',
								data:{value:val},
								dataType:'JSON',
								type:'POST',
								success:function(j){
									if(time != ajaxtime[fname])return;
									if(j.error){
										showError(self,'用户名已被占用');
									}
								}
							})
						}
						break;
					case 'password':
						if(val=='') {
							error = '请填写密码';
						}else if(val.length<6 || val.length>20) {
							error = '密码必须达到6-20位';
						}
						form.find('[name=repassword]').trigger('blur');
						break;
					case 'repassword':
						if($(this).is(':focus'))return;
						if(val!==form.find('[name=password]').val()) {
							error = '两次密码输入不一致';
						}
						break;
					case 'email':
						if(val=='') {
							error = '请填写邮箱';
						}else if(!val.match(/^([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)$/)) {
							error = '邮箱格式不正确';
						}else{
							ajaxtime[fname]=new Date().getTime();
							$.ajax({
								url:'{:U('Login/checkunique',array('type'=>'email'))}',
								data:{value:val},
								dataType:'JSON',
								type:'POST',
								success:function(j){
									if(time != ajaxtime[fname])return;
									if(j.error){
										showError(self,'邮箱已被占用');
									}
								}
							})
						}
						break;
					case 'mobile':
						if(val=='') {
							error = '请填写手机号码';
						}else if(!val.match(/^1[3458679][0-9]{9}$/)) {
							error = '手机号码格式错误';
						}else{
							ajaxtime[fname]=new Date().getTime();
							$.ajax({
								url:'{:U('Login/checkunique',array('type'=>'mobile'))}',
								data:{value:val},
								dataType:'JSON',
								type:'POST',
								success:function(j){
									if(time != ajaxtime[fname])return;
									if(j.error){
										showError(self,'手机号码已被占用');
									}
								}
							})
						}
						break;
					case 'realname':
						if(val=='') {
							error = '请填写真实姓名';
						}
						break;
                    case 'invite_code':
                        if (val == '') {
                            if ('{$config["m_invite"]}' == '2') error = '请填写激活码';
                        } else if (!val.match(/^[a-zA-Z0-9\-]{9,20}$/)) {
                            error = '激活码格式错误';
                        }
                        break;
				}
				if(error) {
					showError(this, error);
					return false;
				}
				return true;
			}).keyup(function() {
				hideError(this);
			});
			$('.remind').each(function() {
				$(this).data('origin',$(this).html());
			});
			function showError(field,msg){
				$(field).addClass('error');
				var msgbox=$(field).parents('.form-group').find('.remind');
				if(msgbox.length<1)return;
				if(!msgbox.data('origin'))msgbox.data('origin',msgbox.html());
				msgbox.text(msg);
			}
			function hideError(field){
				$(field).removeClass('error');
				var msgbox=$(field).parents('.form-group').find('.remind');
				if(msgbox.length<1)return;
				if(msgbox.data('origin')) {
					msgbox.html(msgbox.data('origin'));
				}else {
					msgbox.text('');
				}
			}
		});
	</script>
</block>