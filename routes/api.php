<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ContactsController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/signup', [AuthController::class, 'signup']);
Route::post('/signin', [AuthController::class, 'signin']);

Route::group(['prefix' => 'contacts', 'middleware' => 'auth:api'], function () {
    Route::get('/', [ContactsController::class, 'contactsList']);
    Route::post('/make', [ContactsController::class, 'contactsMake']);
    Route::post('/remove', [ContactsController::class, 'contactsRemove']);
});
