<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class Contacts extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('contacts', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->bigInteger('owner_id');
            $blueprint->bigInteger('contact_user_id');

            $blueprint->unique(['owner_id', 'contact_user_id']);
            $blueprint->foreign('owner_id')->references('id')->on('users')->cascadeOnDelete()->cascadeOnUpdate();
            $blueprint->foreign('contact_user_id')->references('id')->on('users')->cascadeOnDelete()->cascadeOnUpdate();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('contacts');
    }
}
