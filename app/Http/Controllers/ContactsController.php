<?php

namespace App\Http\Controllers;

use App\Models\Contact;
use App\Models\User;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class ContactsController extends Controller
{
    public function contactsList(Request $request)
    {
        $me = Auth::id();
        $queryItems = User::query()->where('id', '!=', $me);

        if ($request->query('only_favorite', 'false') == 'true') {
            $queryItems->whereHas('contacts_reversed', function (Builder $query) use ($me) {
                $query->where('contacts.owner_id', $me);
            });
        }

        $queryCount = clone $queryItems;
        $queryItems->offset($request->query('offset', 0))->limit(5);

        Log::debug($queryItems->toSql());

        $users = $queryItems->get()->keyBy('id');
        $contacts = Contact::query()
            ->where('owner_id', $me)
            ->whereIn('contact_user_id', $users->keys())
            ->get()
            ->keyBy('contact_user_id');

        $users = $users->map(function (User $user) use ($contacts) {
            return [
                'user' => $user->toArray(),
                'contact' => data_get($contacts, $user['id']),
            ];
        })->values();

        return [
            'items' => $users,
            'count' => $queryCount->count(),
        ];
    }

    public function contactsMake(Request $request)
    {
        $data = Validator::make($request->post(), [
            'user_id' => 'required|int|exists:users,id',
        ])->validate();

        $contact = new Contact();
        $contact->owner_id = Auth::id();
        $contact->contact_user_id = $data['user_id'];

        $contact->saveQuietly();

        return $contact;
    }

    public function contactsRemove(Request $request)
    {
        $data = Validator::make($request->post(), [
            'user_id' => 'required|int|exists:users,id',
        ])->validate();

        Contact::query()->where(['contact_user_id' => $data['user_id'], 'owner_id' => Auth::id()])->delete();
    }
}
