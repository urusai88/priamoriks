<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function signin(Request $request)
    {
        $data = Validator::make($request->post(), [
            'name' => 'required|string|min:1',
        ])->validate();

        /** @var User|null $user */
        $user = User::query()->where(['name' => $data['name']])->first();

        if ($user == null) {
            $user = new User();
            $user->name = $data['name'];
            $user->api_token = Str::random();

            $user->saveQuietly();

            return [
                'api_token' => $user->api_token,
            ];
        }

        if (!$user->api_token) {
            $user->api_token = Str::random();
            $user->saveQuietly();
        }

        return [
            'api_token' => $user->api_token,
        ];
    }
}
