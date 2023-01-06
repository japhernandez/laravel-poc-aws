<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    try {
        DB::connection()->getPdo();

        $connection = 'DB connected';

        return view('welcome', ['connection' => $connection]);
    } catch (\Exception $e) {
        $db_connection = env('DB_CONNECTION');
        $db_database = env('DB_DATABASE');
        $db_host = env('DB_HOST');
        $db_port = env('DB_PORT');
        $db_username = env('DB_USERNAME');
        $db_password = env('DB_PASSWORD');
        return "DB disconnected: {$e->getMessage()}, DB_CONNECTION={$db_connection}&DB_DATABASE={$db_database}&DB_HOST={$db_host}&DB_PORT={$db_port}&DB_USERNAME=${db_username}&DB_PASSWORD={$db_password}";
    }

});
