<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int $owner_id
 * @property int $contact_user_id
 */
class Contact extends Model
{
    use HasFactory;

    public $timestamps = false;
    protected $casts = ['owner_id' => 'int', 'contact_user_id' => 'int'];

    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function contactUser()
    {
        return $this->belongsTo(User::class, 'contact_user_id');
    }
}
