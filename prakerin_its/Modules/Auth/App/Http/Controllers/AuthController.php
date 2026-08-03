<?php

namespace Modules\Auth\App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        // Logika validasi dan generate token akan ditaruh di sini
        return response()->json([
            'message' => 'Hit endpoint login berhasil'
        ]);
    }

    public function logout(Request $request)
    {
        // Logika hapus token akan ditaruh di sini
    }
}