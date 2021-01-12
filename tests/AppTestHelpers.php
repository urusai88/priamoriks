<?php

namespace Tests;

/**
 * @mixin \Tests\TestCase
 */
trait AppTestHelpers
{
    /**
     * @param $name
     * @return string
     */
    public function userSignup($name)
    {
        return $this->postJson('/api/signin', ['name' => $name])->json('api_token');
    }
}
