
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