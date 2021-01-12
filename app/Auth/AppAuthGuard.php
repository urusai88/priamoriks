<?php

namespace App\Auth;

use Illuminate\Contracts\Auth\Authenticatable;
use Illuminate\Contracts\Auth\Guard;

class AppAuthGuard implements Guard
{
    public function check()
    {
        var_dump('check');
        // TODO: Implement check() method.
    }

    public function guest()
    {
        var_dump('guest');
        // TODO: Implement guest() method.
    }

    public function user()
    {
        var_dump('user');
        // TODO: Implement user() method.
    }

    public function id()
    {
        var_dump('id');
        // TODO: Implement id() method.
    }

    public function validate(array $credentials = [])
    {
        var_dump('validate');
        // TODO: Implement validate() method.
    }

    public function setUser(Authenticatable $user)
    {
        var_dump('setUser');
        // TODO: Implement setUser() method.
    }

}
