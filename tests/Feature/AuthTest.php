<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\AppTestHelpers;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use DatabaseMigrations;
    use RefreshDatabase;
    use AppTestHelpers;

    public function testSignin()
    {
        // empty request
        $this->postJson('/api/signin')->assertStatus(422);
        // success
        $apiToken = $this->postJson('/api/signin', ['name' => 'name 1'])
            ->assertSuccessful()
            ->assertJsonStructure(['api_token'])
            ->json('api_token');

        // no token
        $this->getJson('/api/user')->assertStatus(401);
        // wrong token
        $this->getJson('/api/user', [
            'authorization' => "Bearer unknown",
        ])->assertStatus(401);
        // good token
        $this->getJson('/api/user', [
            'authorization' => "Bearer $apiToken",
        ])->assertSuccessful()->assertJson(['name' => 'name 1']);
    }
}
