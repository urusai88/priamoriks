<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\AppTestHelpers;
use Tests\TestCase;

class ContactsTest extends TestCase
{
    use DatabaseMigrations;
    use RefreshDatabase;
    use AppTestHelpers;

    protected function setUp(): void
    {
        parent::setUp();

        $this->artisan('db:seed');
    }

    public function testContactsList()
    {
        $apiToken = $this->userSignup('name 666');
        $this->getJson('/api/contacts')->assertStatus(401);
        $resp = $this
            ->getJson('/api/contacts', ['authorization' => "Bearer $apiToken"])
            ->assertSuccessful();

        $json = $resp->json();

        $this->assertArrayHasKey('count', $json);
        $this->assertArrayHasKey('items', $json);

        $count = $json['count'];
        $items = $json['items'];

        $this->assertTrue(is_int($count));
        $this->assertTrue(is_array($items));
    }

    public function testContactToggle()
    {
        $apiToken = $this->userSignup('name 666');
        $me = $this->getJson('/api/user', ['authorization' => "Bearer $apiToken"])->json('id');
        $resp = $this->getJson('/api/contacts', ['authorization' => "Bearer $apiToken"]);
        $json = $resp->json();
        $user1 = data_get($json, 'items.0');

        $this->assertArrayHasKey('contact', $user1);
        $this->assertTrue(is_null($user1['contact']));

        $this->assertDatabaseMissing('contacts', ['owner_id' => $me, 'contact_user_id' => $user1['user']['id']]);

        $this->postJson('/api/contacts/make', [], ['authorization' => "Bearer $apiToken"])->assertStatus(422);
        $this->postJson('/api/contacts/make', ['user_id' => 0], ['authorization' => "Bearer $apiToken"])->assertStatus(422);
        $this->postJson('/api/contacts/make', ['user_id' => $user1['user']['id']], ['authorization' => "Bearer $apiToken"])
            ->assertSuccessful();

        $this->assertDatabaseHas('contacts', ['owner_id' => $me, 'contact_user_id' => $user1['user']['id']]);

        $resp = $this->getJson('/api/contacts', ['authorization' => "Bearer $apiToken"]);

        $json = $resp->json();
        $user1 = data_get($json, 'items.0');

        $this->assertArrayHasKey('contact', $user1);
        $this->assertTrue(!is_null($user1['contact']));

        // remove
        $this->postJson('/api/contacts/remove', ['user_id' => $user1['user']['id']], ['authorization' => "Bearer $apiToken"])
            ->assertSuccessful();
        $this->assertDatabaseMissing('contacts', ['owner_id' => $me, 'contact_user_id' => $user1['user']['id']]);
    }
}
