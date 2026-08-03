<?php

namespace Modules\Auth\App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        // 1. Validasi Input
        $validator = Validator::make($request->all(), [
            'nama_lengkap' => 'required|string|max:255',
            'nik' => 'required|string|size:16|unique:users,nik',
            'email' => 'required|email|unique:users,email',
            'nomor_telepon' => 'required|string|max:15',
            'password' => 'required|string|min:8',
            'is_agreed' => 'accepted'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'message' => 'Data tidak valid',
                'errors' => $validator->errors()
            ], 422);
        }

        // 2. Generate Nomor RM Otomatis (Contoh format: RM-0001)
        $lastUser = User::orderBy('id', 'desc')->first();
        $nextId = $lastUser ? $lastUser->id + 1 : 1;
        $nomorRm = 'RM-' . str_pad($nextId, 4, '0', STR_PAD_LEFT);

        // 3. Simpan User ke Database
        $user = User::create([
            'nama_lengkap' => $request->nama_lengkap,
            'nik' => $request->nik,
            'email' => $request->email,
            'nomor_telepon' => $request->nomor_telepon,
            'password' => Hash::make($request->password),
            'nomor_rm' => $nomorRm,
        ]);

        // 4. Generate Token Sanctum
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Pendaftaran berhasil',
            'data' => [
                'user' => $user,
                'token' => $token,
                'token_type' => 'Bearer'
            ]
        ], 201);
    }

    public function login(Request $request)
    {
        // 1. Validasi Input
        $request->validate([
            'login_id' => 'required|string',
            'password' => 'required|string'
        ]);

        // 2. Cari User berdasarkan Email ATAU Nomor RM
        $user = User::where('email', $request->login_id)
                    ->orWhere('nomor_rm', $request->login_id)
                    ->first();

        // 3. Cek Kredensial
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Email/Nomor RM atau Password salah.'
            ], 401);
        }

        // 4. Generate Token Sanctum
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'data' => [
                'user' => $user,
                'token' => $token,
                'token_type' => 'Bearer'
            ]
        ], 200);
    }

    public function logout(Request $request)
    {
        // Hapus token yang sedang digunakan saat ini
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logout berhasil'
        ], 200);
    }
}