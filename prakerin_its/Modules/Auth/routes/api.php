
<!-- How to Run -->
<!-- Kamu bisa mengetes apakah setup-nya berhasil dengan menjalankan 
 php artisan serve 
 dan mencoba hit 
 [http://127.0.0.1:8000/api/auth/login](http://127.0.0.1:8000/api/auth/login) 
 menggunakan Postman. -->
<?php

use Illuminate\Support\Facades\Route;
use Modules\Auth\App\Http\Controllers\AuthController;

Route::prefix('auth')->group(function () {
    Route::post('/login', [auth_controller::class, 'login']);
    
    // Endpoint yang wajib pakai token (sudah login) ditaruh di dalam middleware ini
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
    });
});