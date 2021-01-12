<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function signup(Request $request)
    {
        $data = Validator::make($request->post(), [
            'name' => 'required|string|unique:users,name|min:1',
        ])->validate();

        $user = new User();
        $user->name = $data['name'];
        $user->api_token = Str::random();

        $user->saveOrFail();

        return [
            'api_token' => $user->api_token,
        ];
    }

    /**
     * @param Request $request
     * @throws \Illuminate\Validation\ValidationException
     */
    public function signin(Request $request)
    {
        $data = Validator::make($request->post(), [
            'name' => 'required|string',
        ])->validate();

        /** @var User $user */
        $user = User::query()->where(['name' => $data['name']])->firstOr(function () {
            throw ValidationException::withMessages([
                'Пользователь с таким именем не найден',
            ]);
        });
        $user->api_token = Str::random();
        $user->save();

        return [
            'api_token' => $user->api_token,
        ];
    }
}
