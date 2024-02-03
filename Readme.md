### 说明

该 **docker** 配置，仅用来做数据库的迁移测试。**mysql**，**redis** 的用户名密码设置可以修改 **.env** 里边对应的位置或新建一个 **.env.local** 文件，将 **.env** 里边对应的配置复制出来修改。
这样，**git** 版本控制会友好一点。

对应端口号，写死在 **compose.yaml** 中了，如果和已有的宿主机端口冲突，可以自行修改。

### 命令

**make** 直接命令，会输出提示。

使用的话，一些命令有先后顺序。有一些命令会重复使用到。一般，**make up**命令会是第一个命令，只有有了环境，才好干事情。**make laravel** 会是第二个命令。创建好了环境，才可以创建项目。

这里把命令再列一遍。

|命令|参数|说明|
|--|--|--|
|make|无|命令提示，相当于 help|
|make up|无|创建镜像，生成容器。第一次生成镜像会久一点，后边会好一些|
|make ps|无|查看容器|
|make down|无|删除容器|
|make laravel|无|创建一个最新版本的 laravel 项目|
|make model|MODEL|创建模型和迁移。这里有一个参数 MODEL。模型一般用单数，且首字母大写，比如 User。迁移生成的表是复数 users。例子：make model MODEL=User|
|make migrate|无|执行迁移生成数据库表。每次执行，都会将以前的表删除掉，从新生成新的表|

### 编写迁移文件

上边所做的那么多，是准备好了环境，创建好了迁移文件。但对具体数据库表而言，有具体的字段和数据类型。这个时候，就需要手动编写迁移文件了。

php 容器在宿主机上有了映射。可以方便打开代码去编写。

[中文文档](https://learnku.com/docs/laravel/10.x/migrations/14885)
[官方文档](https://laravel.com/docs/10.x/migrations)

```
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('nickname', 32)->nullable();
            $table->string('phone_prefix', 8)->default('86')->comment('手机号码前缀');
            $table->string('phone', 16)->nullable();
            $table->unique(['phone', 'phone_prefix']);
            $table->string('avatar', 200)->default('static/image/web/avatar.jpg')->comment('头像');
            $table->string('signature')->default('美的事物是永恒的喜悦！')->nullable()->comment('签名');
            $table->string('os_name', 64)->nullable()->comment('注册时操作系统');
            $table->dateTime('last_login_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
```
