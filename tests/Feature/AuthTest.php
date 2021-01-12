<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use DatabaseMigrations;
    use RefreshDatabase;

    protected function signup($name)
    {
        return $this->postJson('/api/signup', ['name' => $name])->json('api_token');
    }

    public function testSignup()
    {

        $this->postJson('/api/signup')->assertStatus(422);
        $this->postJson('/api/signup', ['name' => ''])->assertStatus(422);
        $this->postJson('/api/signup', ['name' => 'name 1'])->assertJsonStructure(['api_token']);
        $this->postJson('/api/signup', ['name' => 'name 2'])->assertJsonStructure(['api_token']);
        $this->postJson('/api/signup', ['name' => 'name 2'])->assertStatus(422);

        $this->assertDatabaseHas('users', ['name' => 'name 1']);
        $this->assertDatabaseHas('users', ['name' => 'name 2']);
    }

    public function testSignin()
    {
        $apiToken1 = $this->signup('name 1');

        $this->postJson('/api/signin')->assertStatus(422);
        $this->postJson('/api/signin', ['name' => 'name 2'])->assertStatus(422);
        $apiToken2 = $this->postJson('/api/signin', ['name' => 'name 1'])
            ->assertSuccessful()
            ->assertJsonStructure(['api_token'])
            ->json('api_token');

        $this->getJson('/api/user', [
            'authorization' => "Bearer $apiToken2",
        ])->assertSuccessful()->assertJson(['name' => 'name 1']);
    }
}
